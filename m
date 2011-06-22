Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab1FVG4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 02:56:18 -0400
Subject: Re: [RFC][PATCH v2 3/7] NFC: add nfc generic netlink interface
From: Johannes Berg <johannes@sipsolutions.net>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	sameo@linux.intel.com, lauro.venancio@openbossa.org,
	marcio.macedo@openbossa.org, Waldemar.Rymarkiewicz@tieto.com
In-Reply-To: <20110621220510.GG2628@joana> (sfid-20110622_000516_324620_EF3EB907)
References: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org>
	 <1308592212-5755-4-git-send-email-aloisio.almeida@openbossa.org>
	 <20110621220510.GG2628@joana> (sfid-20110622_000516_324620_EF3EB907)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 08:56:11 +0200
Message-ID: <1308725771.3883.0.camel@jlt3.sipsolutions.net> (sfid-20110622_085621_327166_5B269734)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-21 at 19:05 -0300, Gustavo F. Padovan wrote:

> >  static int __init nfc_init(void)
> >  {
> > +	int rc;
> > +
> >  	printk(KERN_INFO "NFC Core ver %s\n", VERSION);
> >  
> > -	return class_register(&nfc_class);
> > +	rc = class_register(&nfc_class);
> > +	if (rc)
> > +		goto err;
> 
> Just return rc here and get rid of the label.


Seriously, please trim your quotes. If you're commenting on a specific
piece of code, you can well remove all the code you're not commenting on
like I did above.

johannes

