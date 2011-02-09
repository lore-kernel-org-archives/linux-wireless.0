Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.3eti.com ([65.220.88.141]:30970 "EHLO webmail.3eti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560Ab1BIRJv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 12:09:51 -0500
From: Chaoxing Lin <CLin@3eti.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
CC: 'Zefir Kurtisi' <zefir.kurtisi@neratec.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC] DFS userspace handler
Date: Wed, 9 Feb 2011 17:09:49 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D0571DD3A@RockMX01.rock.corp>
References: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
 <BD54DDEB2546894FAB0731EA7B0EDF8D0571DC0A@RockMX01.rock.corp>
 <4D52B7DB.8000000@neratec.com>
 <BD54DDEB2546894FAB0731EA7B0EDF8D0571DC34@RockMX01.rock.corp>
 <20110209163030.GD2494@tuxdriver.com>
In-Reply-To: <20110209163030.GD2494@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do we have to choose between hostapd and wpa_supplicant?

Why not a new daemon, e.g. DFSd or radard? So that it can be used intuitively for all master or IBSS modes.


-----Original Message-----
From: John W. Linville [mailto:linville@tuxdriver.com] 
Sent: Wednesday, February 09, 2011 11:31 AM
To: Chaoxing Lin
Cc: 'Zefir Kurtisi'; linux-wireless@vger.kernel.org
Subject: Re: [RFC] DFS userspace handler

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
