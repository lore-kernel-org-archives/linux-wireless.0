Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:44373 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbZEURha convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 13:37:30 -0400
Received: by gxk10 with SMTP id 10so2226934gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2009 10:37:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <60ce8d250905201700v13fe1394l6a9704bb02be3807@mail.gmail.com>
References: <60ce8d250905191048t46e3848fw3416ecd793dab9d1@mail.gmail.com>
	 <20090519175336.GF2691@tuxdriver.com>
	 <60ce8d250905200748p5984df0bl1984f0d3bdaf79b5@mail.gmail.com>
	 <1242854588.7048.13.camel@localhost.localdomain>
	 <60ce8d250905201700v13fe1394l6a9704bb02be3807@mail.gmail.com>
Date: Thu, 21 May 2009 10:37:31 -0700
Message-ID: <45e8e6c40905211037n2e5b8ea9ka85517e127444f2d@mail.gmail.com>
Subject: Re: Throughput is not changed when setting to a much higher bit rate
From: Andrey Yurovsky <andrey@cozybit.com>
To: Dongas <dongas86@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 20, 2009 at 5:00 PM, Dongas <dongas86@gmail.com> wrote:
> 2009/5/21 Dan Williams <dcbw@redhat.com>:
>> On Wed, 2009-05-20 at 22:48 +0800, Dongas wrote:
>>> 2009/5/20 John W. Linville <linville@tuxdriver.com>:
>>> > On Wed, May 20, 2009 at 01:48:32AM +0800, Dongas wrote:
>>> >
>>> >> Why the bandwidth is not changed when bit rate is changed to 11Mb/s?
>>> >> Any thing wrong?
>>> >
>>> > More errors at higher bit rate, resulting in more retries?  Just a
>>> > thought...
>>> >
>>> Is there a quick way to verify this possible reason? I'm using Libertas driver.
>>>
>>> BTW, my sdio host driver is using polling mode to handle SDIO IRQ.
>>> Could this be the cause of such poor performance?
>>
>> Definitely.  With libertas, the largest class of issues by *far* that
>> we've seen are controller related.  I seem to recall that I've pulled
>> about 6Mbps through the card using a normal Ricoh controller from a
>> Fujitsu laptop.  I can recheck that.

For what it's worth, we've seen higher throughput: 20Mbps UDP and
14.7Mbps TCP using SDIO on a ThinkPad with the Ricoh controller.

  -Andrey
