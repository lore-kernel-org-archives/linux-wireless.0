Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:44042 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbZKLSNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 13:13:40 -0500
Received: by iwn8 with SMTP id 8so1965385iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 10:13:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091112181045.GA8839@sig21.net>
References: <20091112152600.GA7562@sig21.net> <20091112181045.GA8839@sig21.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 12 Nov 2009 10:13:26 -0800
Message-ID: <43e72e890911121013t7273c09fybff75fa2484cf07c@mail.gmail.com>
Subject: Re: ath9k: DMA failed to stop in 10 ms
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 12, 2009 at 10:10 AM, Johannes Stezenbach <js@sig21.net> wrote:
> On Thu, Nov 12, 2009 at 04:26:00PM +0100, Johannes Stezenbach wrote:
>>
>> When running kismet I get a lot of
>>
>> [ 2030.531809] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
>
> Update: It seems that this is only happening when kismet is hopping
> channels.  So it looks like an unclean shutdown of the receive
> process and not a real problem -- except that the log flooding is
> pretty annoying.

Can you try disabling powersave before using monitor mode?

sudo iwconfig wlan0 power off

  Luis
