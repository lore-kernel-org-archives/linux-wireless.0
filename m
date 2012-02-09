Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server514a.exghost.com ([72.32.253.68]:4166 "EHLO
	server514.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757020Ab2BICSj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 21:18:39 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH V2] rtlwifi: Return correct failure code on error
Date: Wed, 8 Feb 2012 20:18:35 -0600
Message-ID: <BC8BC73D12649F439B502B4CB6FD58B1053E30FB@BE23.exg4.exghost.com> (sfid-20120209_031845_533888_292982D3)
In-Reply-To: <4F33288C.5090905@lwfinger.net>
References: <20120208211436.GA1309@simgr-precise.oldroadcomputing.net> <4F33288C.5090905@lwfinger.net>
From: "Simon Graham" <simon.graham@virtualcomputer.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Cc: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<chaoming_li@realsil.com.cn>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >   	return 1;
> 
> You must have an extreme memory limitation to find all these problems.
> 

As part of system testing we do

> As long as you are reworking this section, I would prefer you leave
the
> "return
> err" as it is now, change the "return 1" to "return 0", and remove the
> not
> operator in "err = !rtl_pci_init(hw, pdev);" call of this routine. I
> just
> discovered it a few days ago, and it bothers me, but I've been too
busy
> to
> submit a fix. In addition, these changes will convert rtl_pci_init()
> into a more
> normal routine that returns 0 if OK and non-zero on errors.
> 

OK - I'll do that tomorrow and resubmit (hopefully correctly this time!)

> Larry
