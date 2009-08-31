Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP01.calltower.com ([69.4.184.248]:39675 "EHLO
	L01SLCSMTP01.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145AbZHaPut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 11:50:49 -0400
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix uninitialized value use
 in ath5k_eeprom_read_turbo_modes()
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <bcopeland@gmail.com>,
	Pavel Roskin <proski@gnu.org>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890908272221s39df68abq8e146c2d3566b415@mail.gmail.com>
References: <20090827023000.21926.90867.stgit@mj.roinet.com>
	 <40f31dec0908270558y2a3a565bvcc7e470b7f2644c6@mail.gmail.com>
	 <b6c5339f0908271117q3a893d4dma9df0ac441091dbf@mail.gmail.com>
	 <43e72e890908271125x378da3abw41e7f73dd8fbfe81@mail.gmail.com>
	 <40f31dec0908272001u1a67cbf3ycc5d9588dd48915d@mail.gmail.com>
	 <43e72e890908272057s28ee11c6x624e8a08c6bd17e9@mail.gmail.com>
	 <40f31dec0908272117s27b3a59ep5f18c85aa179793d@mail.gmail.com>
	 <43e72e890908272221s39df68abq8e146c2d3566b415@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 31 Aug 2009 10:49:55 -0500
Message-Id: <1251733795.23917.1.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-08-27 at 22:21 -0700, Luis R. Rodriguez wrote:

> > Having multiple drivers won't help users, i thought that MadWiFi was "dead"
> > and we were working on a complete alternative.
> 
> MadWifi is dead.
> 
>   Luis

An interesting pronouncement.  Do you mean "Dead to Linux"?
Or "Dead to the world, including FreeBSD"?

jdl


