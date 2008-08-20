Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4778 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbYHTTcz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2008 15:32:55 -0400
Date: Wed, 20 Aug 2008 15:28:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: kilroyd@googlemail.com
Cc: linux-wireless@vger.kernel.org, proski@gnu.org,
	orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: Re: [PATCH 00/19] orinoco: WPA for Agere based cards
Message-ID: <20080820192812.GA1746@tuxdriver.com> (sfid-20080820_213301_414483_78879B14)
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 02, 2008 at 11:14:14AM +0100, kilroyd@googlemail.com wrote:
> This patch series enables WPA on Agere based orinoco devices.
> 
> Patchset overview
> 1-2: General scanning updates
> 3-9: Agere firmware download to RAM
> 10-12: Update orinoco to work with new firmware
> 13-19: WPA functionality
> 
> This patchset is against wireless-testing (master-2008-07-16), is
> sparse clean (UP), and should be bisectable. It is almost checkpatch
> clean - the single warning looks like a false positive to me.

Are we satisfied w/ this patch series?  If so, could I ask Dave to
repost them as a single series (rather than having to randomly replace
some of them) in the middle?

> To use WPA, you will need an Agere firmware image. You can get the
> necessary file at
> <http://marc.info/?l=orinoco-devel&m=121078835610877>, just extract
> and rename orinoco.fw to agere_sta_fw.bin and place it in
> /lib/firmware (or distro equivalent). Alternatively you can try
> extract firmware from a Windows driver using the program in
> <http://marc.info/?l=orinoco-devel&m=120846933719051>.

Is the above documented anywhere other than this email thread?

John
-- 
John W. Linville
linville@tuxdriver.com
