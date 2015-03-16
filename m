Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964873AbbCPRHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 13:07:20 -0400
Date: Mon, 16 Mar 2015 18:07:14 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	"M. Vefa Bicakci" <m.v.b@runbox.com>,
	Matthias Beyer <mail@beyermatthias.de>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH v2 00/16] checkpatch clean-up of rtl8723au's
 rtw_security.c
Message-ID: <20150316170714.GB20171@kroah.com> (sfid-20150316_180737_868213_466FEB8D)
References: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
 <20150315093142.GY24643@lucy.3gs>
 <10669062.ZZNVxH5Tl9@lenny>
 <wrfjvbi1rkwy.fsf@ultrasam.lan.trained-monkey.org>
 <1426524927.23897.9.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426524927.23897.9.camel@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 16, 2015 at 09:55:27AM -0700, Joe Perches wrote:
> On Mon, 2015-03-16 at 12:01 -0400, Jes Sorensen wrote:
> > For staging patches, you should always post patches against the
> > staging-next tree. Please rebase them and repost them.
> 
> Greg is now preferring patches against his
> staging-testing branch
> 

staging-testing only lasts a day or so before it turns into
staging-next, so you are usually safe with using staging-next.

thanks,

greg k-h
