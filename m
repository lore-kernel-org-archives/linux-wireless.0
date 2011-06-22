Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37900 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042Ab1FVTzb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 15:55:31 -0400
Received: by vxb39 with SMTP id 39so851479vxb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 12:55:30 -0700 (PDT)
Date: Wed, 22 Jun 2011 16:55:48 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	sameo@linux.intel.com, lauro.venancio@openbossa.org,
	marcio.macedo@openbossa.org, Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [RFC][PATCH v2 3/7] NFC: add nfc generic netlink interface
Message-ID: <20110622195548.GB2583@joana> (sfid-20110622_215534_801920_7C08D2CD)
References: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org>
 <1308592212-5755-4-git-send-email-aloisio.almeida@openbossa.org>
 <20110621220510.GG2628@joana>
 <1308725771.3883.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1308725771.3883.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

* Johannes Berg <johannes@sipsolutions.net> [2011-06-22 08:56:11 +0200]:

> On Tue, 2011-06-21 at 19:05 -0300, Gustavo F. Padovan wrote:
> 
> > >  static int __init nfc_init(void)
> > >  {
> > > +	int rc;
> > > +
> > >  	printk(KERN_INFO "NFC Core ver %s\n", VERSION);
> > >  
> > > -	return class_register(&nfc_class);
> > > +	rc = class_register(&nfc_class);
> > > +	if (rc)
> > > +		goto err;
> > 
> > Just return rc here and get rid of the label.
> 
> 
> Seriously, please trim your quotes. If you're commenting on a specific
> piece of code, you can well remove all the code you're not commenting on
> like I did above.

Sorry, I didn't realize that it was so big. Also I usually forget to trim the
beginning of the patch. Have to get used to that.

	Gustavo
