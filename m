Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab3C1JCl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 05:02:41 -0400
Date: Thu, 28 Mar 2013 10:03:24 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ali Ustek <aliustek@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	1156363@bugs.launchpad.net
Subject: Re: Fwd: Ralink RT3290 card not supported
Message-ID: <20130328090323.GA1384@redhat.com> (sfid-20130328_100246_799659_C9F3F4D0)
References: <CAGmUV-ugMOOv_OhG4+0CcQqJF1-nfRPUNwGtnzNRodXMOqS-bA@mail.gmail.com>
 <CAGmUV-vhBavw5=fM=Xt-bJVLp2zZSghrfOcWgHsYt_97_wy+4Q@mail.gmail.com>
 <CAGmUV-v9Bpn53JNYvmLpChtK_1Zj+ms0JGZC0=Tyc96SGfngLw@mail.gmail.com>
 <515392AF.8070809@lwfinger.net>
 <CAGmUV-tCwDd7+g1k0=xnAx03bjxVnPXhf6uSU+Fa4Oo2EQPizA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGmUV-tCwDd7+g1k0=xnAx03bjxVnPXhf6uSU+Fa4Oo2EQPizA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 28, 2013 at 08:18:37AM +0000, Ali Ustek wrote:
> >> The wi-fi chip Ralink RT3290 is common in notebooks but is not
> >> supported by linux-kernel

This device is supported since 3.7 . You most likely compile kernel
without CONFIG_RT2800PCI_RT3290.

Stanislaw
