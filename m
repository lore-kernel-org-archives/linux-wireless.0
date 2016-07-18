Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40166 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbcGRTds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:33:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wlcore/wl18xx: mesh: added initial mesh support for wl8
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160628104305.4533-1-yanivma@ti.com>
To: "Machani, Yaniv" <yanivma@ti.com>
Cc: <linux-kernel@vger.kernel.org>, Maital Hahn <maitalm@ti.com>,
	Yaniv Machani <yanivma@ti.com>,
	Eliad Peller <eliad@wizery.com>, Guy Mishol <guym@ti.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Arik Nemtsov <arik@wizery.com>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Message-Id: <20160718193347.4F5CD602A9@smtp.codeaurora.org> (sfid-20160718_213410_728981_793F7D33)
Date: Mon, 18 Jul 2016 19:33:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Machani, Yaniv" <yanivma@ti.com> wrote:
> From: Maital Hahn <maitalm@ti.com>
> 
> 1. Added support for interface and role of mesh type.
> 2. Enabled enable/start of mesh-point role,
>    and opening and closing a connection with a mesh peer.
> 3. Added multirole combination of mesh and ap
>    under the same limits of dual ap mode.
> 4. Add support for 'sta_rc_update' opcode for mesh IF.
>    The 'sta_rc_update' opcode is being used in mesh_plink.c.
> Add support in wlcore to handle this opcode correctly for mesh
> (as opposed to current implementation that handles STA only).
> 5. Bumped the firmware version to support new Mesh functionality
> 
> Signed-off-by: Maital Hahn <maitalm@ti.com>
> Signed-off-by: Yaniv Machani <yanivma@ti.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

c0174ee28003 wlcore/wl18xx: mesh: added initial mesh support for wl8

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9202707/

