Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr6.hinet.net ([168.95.4.106]:56891 "EHLO msr6.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab1GSNb0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 09:31:26 -0400
Date: Tue, 19 Jul 2011 21:28:38 +0800
From: Ali Bahar <ali@internetdog.org>
To: Stefan Assmann <sassmann@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: r8712u issue
Message-ID: <20110719132838.GA5959@internetdog.org> (sfid-20110719_153129_571652_E54AEE6B)
Reply-To: ali@internetdog.org
References: <4E2051F3.20103@redhat.com>
 <4E205984.5040803@lwfinger.net>
 <4E23E56C.9000202@redhat.com>
 <20110718082709.GA8390@internetdog.org>
 <4E23F2E0.3050200@redhat.com>
 <4E2448D2.50502@lwfinger.net>
 <4E244AC6.2030306@redhat.com>
 <4E2454EC.1050900@lwfinger.net>
 <4E25858D.9010407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E25858D.9010407@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 19, 2011 at 03:24:29PM +0200, Stefan Assmann wrote:
> On 18.07.2011 17:44, Larry Finger wrote:
> > On 07/18/2011 10:01 AM, Stefan Assmann wrote:
> >> On 18.07.2011 16:53, Larry Finger wrote:
> >>> On 07/18/2011 03:46 AM, Stefan Assmann wrote:

> >>> Please post your wpa_supplicant.conf. In particular, what is the value for
> >>> scan_ssid?
> >>
> >> ctrl_interface=/var/run/wpa_supplicant
> >> eapol_version=1
> >> ap_scan=2
> >>
> >> network={
> >>          ssid="<ssid>"
> >>          id_str="<ssid>"
> >>          priority=5
> >>          proto=RSN
> >>          key_mgmt=WPA-PSK
> >>          psk=<psk>
> >> }
> >>
> >> Should I try again with scan_ssid=1 ? From reading the man page this
> >> makes a difference if the ssid is hidden, which is not the case.
> > 
> > Yes. It also changes the scan behavior.
> 
> So far I can say that with scan_ssid=1 after rebooting the AP the
> connection is properly re-established. Looks promising.

I have not yet managed to reproduce your problem, unfortunately. I
will watch for it, though.

regards,
ali


 
>   Stefan
> 
