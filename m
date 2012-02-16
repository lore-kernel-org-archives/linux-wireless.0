Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab2BPMzZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 07:55:25 -0500
Date: Thu, 16 Feb 2012 13:55:23 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [rt2x00] rt2800usb and RT3070 issues with 54G AP
Message-ID: <20120216125522.GF25833@redhat.com> (sfid-20120216_135528_897762_0DE18CDE)
References: <1329061551.67805.YahooMailClassic@web161605.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1329061551.67805.YahooMailClassic@web161605.mail.bf1.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 12, 2012 at 07:45:51AM -0800, Walter Goldens wrote:
> My rt3070 USB card works flawlessly when connected to an 802.11N AP. Excellent throughput, speed and reliability.
> 
> When connected to a 54G AP however, there is significant packet loss and duplicates.
> I can confirm this to be happening with two older 54G APs, and not with a single N AP.
>
> Does anyone else have the same problem?

Usually we have opposite problem, 11g works, 11n does not.

Are you using the lates wireless-testing tree? If not, try that
i.e using compat-wireless package there are some pending radio chip
programing fixes, I think they may help with packet lost.

Stanislaw   
