Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43309 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2EZFsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 01:48:19 -0400
Received: by wgbdr13 with SMTP id dr13so1442107wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2012 22:48:18 -0700 (PDT)
References: <4FC04B5A.1070900@candelatech.com> <20416.19680.571601.549629@gargle.gargle.HOWL>
In-Reply-To: <20416.19680.571601.549629@gargle.gargle.HOWL>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <7759D07D-C2C8-48D8-8F44-687C7E85D188@gmail.com> (sfid-20120526_074852_929625_D8590C35)
Cc: Ben Greear <greearb@candelatech.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Joe Semler <josef.semler@gmail.com>
Subject: Re: [ath9k-devel] Anyone doing WiFi throughput tests?
Date: Sat, 26 May 2012 07:48:20 +0200
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>





Am 26.05.2012 um 05:24 schrieb Sujith Manoharan <c_manoha@qca.qualcomm.com>:

> Ben Greear wrote:
>> We've been doing some tests using Atheros stations and various APs.  The max throughput
>> we've seen so far is about 237Mbps (received UDP payload on the stations).
>> (Open-Air, AP about 5 feet away, 3x3 MIMO, HT40, 5Ghz, etc).
>> 
>> We are still running lots of different permutations, but I am interested if
>> anyone else has any numbers to share (official or otherwise).
> 
> Which card/chip ?
> 
> With a XB112 card (3x3) in HT40 mode, 5Ghz, TX throughput (TCP) can reach 290 Mbps.
> Sample iperf run:
> 
> [  3] 28.0-29.0 sec  34.1 MBytes   286 Mbits/sec
> [  3] 29.0-30.0 sec  34.6 MBytes   290 Mbits/sec
> [  3] 30.0-31.0 sec  34.8 MBytes   292 Mbits/sec
> [  3] 31.0-32.0 sec  34.8 MBytes   292 Mbits/sec
> [  3] 32.0-33.0 sec  34.9 MBytes   293 Mbits/sec

Do you use ath9k for that purpouse? I was thinking our driver is not able to operate MIMO.
Some changes that i missed?

JoeSemler
> 
> Sujith
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
