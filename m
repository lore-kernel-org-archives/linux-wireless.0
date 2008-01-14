Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60934 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYANSkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 13:40:52 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] iwlwifi: fix bad unlock balance
Date: Mon, 14 Jan 2008 10:38:50 -0800
Message-ID: <D936D925018D154694D8A362EEB089200364DDED@orsmsx416.amr.corp.intel.com> (sfid-20080114_184056_005970_8CA6EEF6)
In-Reply-To: <1200046964.3861.157.camel@johannes.berg>
References: <1200046964.3861.157.camel@johannes.berg>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>, "Tomas Winkler" <tomasw@gmail.com>,
	"Christoph Hellwig" <hch@infradead.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Johannes Berg wrote:

> 
>        iwl4965_resume(priv);
>        mutex_unlock(&priv->mutex);                  /*** not
> locked!! ***/
> 
>        return 0;
> }

This was fixed in 5b9264550dc190b7330a4bde615083883c1cde11 ("iwlwifi:
fix-up damage from rebase of namespace separation patches")

Thanks!

Reinette
