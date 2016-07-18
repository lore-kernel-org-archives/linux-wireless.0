Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:60323 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbcGRS1U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 14:27:20 -0400
From: "Machani, Yaniv" <yanivma@ti.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Hahn, Maital" <maitalm@ti.com>, Eliad Peller <eliad@wizery.com>,
	"Mishol, Guy" <guym@ti.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Arik Nemtsov <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] wlcore/wl18xx: mesh: added initial mesh support for wl8
Date: Mon, 18 Jul 2016 18:27:15 +0000
Message-ID: <AE1C82FB3D0EC64DB1F752C81CBD11013920461D@DFRE01.ent.ti.com> (sfid-20160718_202724_457649_C1AB5875)
References: <20160628104305.4533-1-yanivma@ti.com>
 <87eg6qx2ou.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87eg6qx2ou.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 18, 2016 at 20:42:57, Kalle Valo wrote:
> Guy; Johannes Berg; Arik Nemtsov; linux-wireless@vger.kernel.org; 
> netdev@vger.kernel.org
> Subject: Re: [PATCH] wlcore/wl18xx: mesh: added initial mesh support 
> for wl8
> 
> Yaniv Machani <yanivma@ti.com> writes:
> 
> > From: Maital Hahn <maitalm@ti.com>
> >
> > 1. Added support for interface and role of mesh type.
> > 2. Enabled enable/start of mesh-point role,
> >    and opening and closing a connection with a mesh peer.
> > 3. Added multirole combination of mesh and ap
> >    under the same limits of dual ap mode.
> > 4. Add support for 'sta_rc_update' opcode for mesh IF.
> >    The 'sta_rc_update' opcode is being used in mesh_plink.c.
> > Add support in wlcore to handle this opcode correctly for mesh (as 
> > opposed to current implementation that handles STA only).
> > 5. Bumped the firmware version to support new Mesh functionality
> >
> > Signed-off-by: Maital Hahn <maitalm@ti.com>
> > Signed-off-by: Yaniv Machani <yanivma@ti.com>
> 
> Does this depend on any mac80211 patches? To not break anything I 
> can't apply this until all the dependencies are in my tree.
> 

Hi Kalle,
No, there are no dependencies for this patch.
The other set of patches are bug fixes and improvements, shouldn't block the merge.

Thanks,
Yaniv


