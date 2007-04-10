Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.235]:55811 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbXDJOo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2007 10:44:59 -0400
Received: by nz-out-0506.google.com with SMTP id s1so1329375nze
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2007 07:44:58 -0700 (PDT)
Message-ID: <f6ca9fed0704100744p565ac578n234ecc4a98535c46@mail.gmail.com>
Date: Tue, 10 Apr 2007 16:44:58 +0200
From: "dragoran dragoran" <drago01@gmail.com>
To: "Larry Finger" <larry.finger@lwfinger.net>
Subject: Re: mac80211 does not support WPA when used with wext
Cc: "Michael Wu" <flamingice@sourmilk.net>,
	"Dan Williams" <dcbw@redhat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John Linville" <linville@redhat.com>, "Jiri Benc" <jbenc@suse.cz>,
	ipw3945-devel@lists.sourceforge.net, jketreno@linux.intel.com
In-Reply-To: <461BA189.9030903@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <460E2B8C.4030002@gmail.com>
	 <200703311700.52792.flamingice@sourmilk.net>
	 <f6ca9fed0704081445u5536e596m4ca4caeb44f7f87@mail.gmail.com>
	 <200704081754.24937.flamingice@sourmilk.net>
	 <f6ca9fed0704081527j641a4ecat44151e107cab7342@mail.gmail.com>
	 <461B3930.6040203@gmail.com> <461BA189.9030903@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/10/07, Larry Finger <larry.finger@lwfinger.net> wrote:
> dragoran wrote:
> > ioctl[SIOCSIWAUTH]: Operation not supported
> > WEXT auth param 4 value 0x0 - wpa_driver_wext_set_drop_unencrypted
> > ioctl[SIOCSIWAUTH]: Operation not supported
> > ----
> > notice the *ioctl[SIOCSIWAUTH]: Operation not supported* what is
> > SIOCSIWAUTH and how does it not being supproted affect wpa/wext support?
>
> I agree with Dan Williams that this message is not critical. Michael Buesch
> uses WPA with mac80211,
> and his version doesn't support SIOCSIWAUTH either.
>
> I'm beginning to think that there is a problem with certain AP's. What is
> the make and model of
> yours? What firmware version is it using? I cannot connect to my Linksys
> WRT54G V5 with or without
> WPA enabled. I'm running v1.02.00 of the firmware (the latest).
>
its a rt2500usb device used with hostapd  (on FC6 x86_64)
> Larry
>
