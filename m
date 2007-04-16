Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from honk1.physik.uni-konstanz.de ([134.34.140.224]:50077 "EHLO
	honk1.physik.uni-konstanz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131AbXDPJB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2007 05:01:58 -0400
Date: Mon, 16 Apr 2007 10:29:12 +0200
From: Guido Guenther <agx@sigxcpu.org>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [at76_usb] kernel panic in update_wstats()
Message-ID: <20070416082912.GA19004@bogon.ms20.nix>
References: <20070415205619.6747d9ed@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070415205619.6747d9ed@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 15, 2007 at 08:56:19PM +0200, Stefano Brivio wrote:
> I'm using the at76c503a driver (0.14beta1, but it looks almost identical
> to a76c503a git) on Linux 2.6.18.
Are you sure you're running a version that has this fix from git:
4b50804c047272075f07edb5b62d857e3200d6a0

If you already have this fix, please try to comment out the different
at76_calc_* functions to see which one causes the problem.
Cheers,
 -- Guido

