Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2398 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbZBIPPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 10:15:25 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Russ Dill <russ.dill@gmail.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Cc: Tulio Magno Quites Machado Filho <tuliom@gmail.com>
Subject: Re: ath5k LEDs on Acer Ferrari 5000 laptop
Date: Mon, 9 Feb 2009 10:14:27 -0500
Message-Id: <20090209151221.M9585@bobcopeland.com> (sfid-20090209_161530_268120_77C4B006)
In-Reply-To: <f9d2a5e10902082209h33afe4dey4930f23c3f178bc8@mail.gmail.com>
References: <f9d2a5e10902082209h33afe4dey4930f23c3f178bc8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 8 Feb 2009 23:09:49 -0700, Russ Dill wrote
> I have an Acer Ferrari 5000 laptop with an ath5k wireless chipset. It
> has an LED built into the rfkill switch on the front of the laptop. I
> testing various settings within the ath5k driver an the led is on pin
> 1 (sc->led_pin = 1) and it is active high (sc->led_on).

When you say it is hooked up to rfkill, do you mean that enabling
the rfkill turns off the led without the emachines patch?  Some
laptops have the led tied to rfkill in such a way that we don't
actually need/want to program it from software.

-- 
Bob Copeland %% www.bobcopeland.com


