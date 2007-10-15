Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7825 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbXJOHVE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 03:21:04 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] move wlan_*_association_work from header to c file
Date: Mon, 15 Oct 2007 09:18:02 +0200
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
References: <200710111151.06989.hs4233@mail.mn-solutions.de> <20071011141642.GA6976@infradead.org> <1192114234.31895.5.camel@localhost.localdomain>
In-Reply-To: <1192114234.31895.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710150918.02708.hs4233@mail.mn-solutions.de> (sfid-20071015_082107_105918_E8C589C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> wlan_set_essid -> lts_set_essid
> wlan_private -> lts_private
>
> (I don't really like 'lbs' personally but I'm not that
> strongly against it)

I've used lbs_XXX and LBS_DEB_xxx for the debugging stuff. Do you 
want to get that changed to lts_XXX and LTS_DEB_xxx, too?

(I personally like lbs more, but am also not strongly for it or 
against something else, I just want to keep things orthogonal)
