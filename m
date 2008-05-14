Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:35019 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbYENSpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 14:45:55 -0400
Received: by fk-out-0910.google.com with SMTP id 18so21679fkq.5
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2008 11:45:54 -0700 (PDT)
Message-ID: <eb97335b0805141145v3436e0e3ld7bd2721cbf0d15f@mail.gmail.com> (sfid-20080514_204559_936578_5594388F)
Date: Wed, 14 May 2008 14:45:54 -0400
From: "Zack Weinberg" <zackw@panix.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: Getting ath5k driver working with Thinkpad T61 [168c:1014]
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <b6c5339f0805141138o5575095du1f12c62624c80630@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <eb97335b0805141024w6afa864j860b312b072faa8a@mail.gmail.com>
	 <b6c5339f0805141138o5575095du1f12c62624c80630@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 14, 2008 at 2:38 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Wed, May 14, 2008 at 1:24 PM, Zack Weinberg <zackw@panix.com> wrote:
>> [15498.709195] ACPI: PCI interrupt for device 0000:03:00.0 disabled
>> [15498.709205] ath5k_pci: probe of 0000:03:00.0 failed with error -5
>
> Did you try power-cycling your machine?  Looks like chip is hung.

exactly the same thing happens immediately after cold boot with
nothing else having touched the chip.

zw
