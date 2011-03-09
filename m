Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135Ab1CIKhM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 05:37:12 -0500
Date: Wed, 9 Mar 2011 11:36:38 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ivdoorn@gmail.com, Johannes Stezenbach <js@sig21.net>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: Unplugging usb wlan (rt73usb) hangs the system
Message-ID: <20110309103633.GB23594@redhat.com>
References: <4D6E7B55.6010905@pardus.org.tr>
 <20110309100651.GA23594@redhat.com>
 <4D77539A.90300@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4D77539A.90300@pardus.org.tr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

On Wed, Mar 09, 2011 at 12:16:58PM +0200, Ozan Çağlayan wrote:
> On 09.03.2011 12:06, Stanislaw Gruszka wrote:
> 
> > 
> > I can confirm problem exist in 2.6.37. I can not reproduce it in
> > current wireless-testing. I did not investigate further, I guess
> > issue is fixed by:
> > 
> > commit d7bb5f845f437662296adbfeaab8fbfce1c32289
> > Author: Johannes Stezenbach <js@sig21.net>
> > Date:   Mon Dec 13 12:32:49 2010 +0100
> > 
> >     rt2x00: fix hang when unplugging USB device in us
> > 
> 
> Hi, I'll test ASAP and if we confirm that it's the fix, it should be (it
> should have been actually with a commit message that serious) CC'ed to
> stable@kernel.org.

Plese test also that one.

commit 070192dd2975c0e97bbdeac7623b755235c6db7d
Author: Ivo van Doorn <ivdoorn@gmail.com>
Date:   Thu Nov 4 20:41:05 2010 +0100

    rt2x00: Fix crash on USB unplug

Thanks 
Stanislaw
