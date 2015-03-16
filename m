Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0184.hostedemail.com ([216.40.44.184]:45329 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932193AbbCPRMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 13:12:09 -0400
Message-ID: <1426525919.23897.11.camel@perches.com> (sfid-20150316_181247_230243_BD2F2476)
Subject: Re: [PATCH v2 00/16] checkpatch clean-up of rtl8723au's
 rtw_security.c
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	"M. Vefa Bicakci" <m.v.b@runbox.com>,
	Matthias Beyer <mail@beyermatthias.de>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net
Date: Mon, 16 Mar 2015 10:11:59 -0700
In-Reply-To: <20150316170714.GB20171@kroah.com>
References: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
	 <20150315093142.GY24643@lucy.3gs> <10669062.ZZNVxH5Tl9@lenny>
	 <wrfjvbi1rkwy.fsf@ultrasam.lan.trained-monkey.org>
	 <1426524927.23897.9.camel@perches.com> <20150316170714.GB20171@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-16 at 18:07 +0100, Greg KH wrote:
> On Mon, Mar 16, 2015 at 09:55:27AM -0700, Joe Perches wrote:
> > On Mon, 2015-03-16 at 12:01 -0400, Jes Sorensen wrote:
> > > For staging patches, you should always post patches against the
> > > staging-next tree. Please rebase them and repost them.
> > Greg is now preferring patches against his
> > staging-testing branch
> staging-testing only lasts a day or so before it turns into
> staging-next, so you are usually safe with using staging-next.

Yeah but that usually is nothing but painful for
those that are unfortunate enough to hit it.


