Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr19.hinet.net ([168.95.4.119]:45655 "EHLO msr19.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab1GSRyd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 13:54:33 -0400
Date: Wed, 20 Jul 2011 01:51:36 +0800
From: Ali Bahar <ali@internetdog.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stefan Assmann <sassmann@redhat.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: r8712u issue
Message-ID: <20110719175136.GA7689@internetdog.org> (sfid-20110719_195438_223164_BFD5FBBD)
Reply-To: ali@internetdog.org
References: <4E2448D2.50502@lwfinger.net>
 <4E244AC6.2030306@redhat.com>
 <4E2454EC.1050900@lwfinger.net>
 <4E25858D.9010407@redhat.com>
 <4E25AB9F.8010607@lwfinger.net>
 <20110719161656.GA7099@internetdog.org>
 <4E25BBF4.1010003@redhat.com>
 <20110719173203.GA7406@internetdog.org>
 <4E25C12F.3080804@redhat.com>
 <4E25C2B1.2090804@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E25C2B1.2090804@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 19, 2011 at 12:45:21PM -0500, Larry Finger wrote:
> On 07/19/2011 12:38 PM, Stefan Assmann wrote:
> >On 19.07.2011 19:32, Ali Bahar wrote:

> >>>Agreed! Maybe we could add a note to the documentation to make the
> >>>behaviour more obvious.

> >>... The following could be an option:
> >>http://linuxwireless.org/en/users/Drivers/rtl819x
> >
> >Good idea!

> The wpa_supplicant documentation is what should be changed to note
> that scan_ssid is useful for more than hidden ESSIDs. On the other

I assume that you've informed Jouni (hostap@lists.shmoo.com) already.


> hand, EVERY wireless example in 'man wpa_supplicant.conf' shows
> "scan_ssid=1".

They do, but none of the examples in
/usr/share/doc/wpasupplicant/examples/ uses it.

regards,
ali

 
> Larry
