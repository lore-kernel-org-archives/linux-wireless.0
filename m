Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:45455 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754203Ab1BIRvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 12:51:32 -0500
Date: Wed, 9 Feb 2011 19:50:44 +0200
From: Jouni Malinen <j@w1.fi>
To: Chaoxing Lin <CLin@3eti.com>
Cc: "'John W. Linville'" <linville@tuxdriver.com>,
	"'Zefir Kurtisi'" <zefir.kurtisi@neratec.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] DFS userspace handler
Message-ID: <20110209175044.GA13242@jm.kir.nu>
References: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
 <BD54DDEB2546894FAB0731EA7B0EDF8D0571DC0A@RockMX01.rock.corp>
 <4D52B7DB.8000000@neratec.com>
 <BD54DDEB2546894FAB0731EA7B0EDF8D0571DC34@RockMX01.rock.corp>
 <20110209163030.GD2494@tuxdriver.com>
 <BD54DDEB2546894FAB0731EA7B0EDF8D0571DD3A@RockMX01.rock.corp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D0571DD3A@RockMX01.rock.corp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 09, 2011 at 05:09:49PM +0000, Chaoxing Lin wrote:
> Do we have to choose between hostapd and wpa_supplicant?

No, but it should be noted that either one of those is most likely going
to be present on the system anyway if any sort of security is used in
AP/WDS/mesh/IBSS/STA.

> Why not a new daemon, e.g. DFSd or radard? So that it can be used intuitively for all master or IBSS modes.

One more interface to define and implement (user space between that new
daemon and hostapd/wpa_supplicant).. I'm not strongly against this, but
I would expect it to increase the total amount of work needed.

-- 
Jouni Malinen                                            PGP id EFC895FA
