Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:65470 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbZCaAbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 20:31:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniele Napolitano <dnax88@gmail.com>
Subject: Re: Additional USB identifier for rt2870 driver
Date: Tue, 31 Mar 2009 02:30:27 +0200
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <15d0b9b20903301624j45040f38tdd1ce5400bbaa247@mail.gmail.com>
In-Reply-To: <15d0b9b20903301624j45040f38tdd1ce5400bbaa247@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903310230.27755.arnd@arndb.de> (sfid-20090331_023118_560870_9A7C91C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 31 March 2009, Daniele Napolitano wrote:
> --- rt2870.h 2009-02-07 01:27:09.000000000 +0100
> +++ rt2870.h~ 2009-02-07 01:26:58.000000000 +0100

This patch does not apply with -p1, please make sure that you generate
your files according to Documentation/SubmittingPatches in the future.

As this is a patch for a staging driver, you should also Cc
Greg Kroah-Hartman <gregkh@suse.de>, because he is maintaining
the staging drivers.

	Arnd <><
