Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31689 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089AbZJSQeY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 12:34:24 -0400
Subject: Re: [PATCH 10/10] iwlwifi: rework for static power save
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1ba2fa240910161615h75a74e13u8a31c3e49eae234a@mail.gmail.com>
References: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
	 <1255728358-29976-11-git-send-email-reinette.chatre@intel.com>
	 <1ba2fa240910161615h75a74e13u8a31c3e49eae234a@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 19 Oct 2009 09:32:00 -0700
Message-Id: <1255969920.10507.0.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tom,

Thanks for the feedback, I will submit a cleanup patch to address this
mistake.
 
On Fri, 2009-10-16 at 16:15 -0700, Tomas Winkler wrote:
> >  #include "iwl-commands.h"
> >
> > +#define IWL_CONN_LISTEN_INTERVAL       10
> 
> There is already IWL_CONN_MAX_LISTEN_INTERVAL; defined
> 
> Thanks
> Tomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

