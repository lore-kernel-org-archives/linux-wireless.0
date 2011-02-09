Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60241 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1BIQpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 11:45:31 -0500
Date: Wed, 9 Feb 2011 11:30:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Chaoxing Lin <CLin@3eti.com>
Cc: "'Zefir Kurtisi'" <zefir.kurtisi@neratec.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] DFS userspace handler
Message-ID: <20110209163030.GD2494@tuxdriver.com>
References: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
 <BD54DDEB2546894FAB0731EA7B0EDF8D0571DC0A@RockMX01.rock.corp>
 <4D52B7DB.8000000@neratec.com>
 <BD54DDEB2546894FAB0731EA7B0EDF8D0571DC34@RockMX01.rock.corp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D0571DC34@RockMX01.rock.corp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 09, 2011 at 04:09:08PM +0000, Chaoxing Lin wrote:
> I would vote for a dedidate DFS daemon.
> 
> Straightforward name is better. 
> Beginners would be hard to understand why WDS/Mesh/IBSS mode requires a hostapd daemon which intuitively means for AP mode..

Perhaps it can be in wpa_supplicant instead?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
