Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:44394 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbYENSiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 14:38:52 -0400
Received: by rv-out-0506.google.com with SMTP id l9so23653rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2008 11:38:50 -0700 (PDT)
Message-ID: <b6c5339f0805141138o5575095du1f12c62624c80630@mail.gmail.com> (sfid-20080514_203855_948422_DD069C29)
Date: Wed, 14 May 2008 14:38:50 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Zack Weinberg" <zackw@panix.com>
Subject: Re: Getting ath5k driver working with Thinkpad T61 [168c:1014]
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <eb97335b0805141024w6afa864j860b312b072faa8a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb97335b0805141024w6afa864j860b312b072faa8a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 14, 2008 at 1:24 PM, Zack Weinberg <zackw@panix.com> wrote:
> [15498.709195] ACPI: PCI interrupt for device 0000:03:00.0 disabled
> [15498.709205] ath5k_pci: probe of 0000:03:00.0 failed with error -5

Did you try power-cycling your machine?  Looks like chip is hung.

-- 
Bob Copeland %% www.bobcopeland.com
