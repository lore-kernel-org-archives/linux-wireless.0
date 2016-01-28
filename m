Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34998 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbcA1FPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 00:15:12 -0500
Message-ID: <56A9A339.8040108@codeaurora.org> (sfid-20160128_061518_919507_5AF2AEF0)
Date: Wed, 27 Jan 2016 21:12:25 -0800
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
CC: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	ath10k@lists.infradead.org, Peter Oh <poh@qca.qualcomm.com>
Subject: Re: [PATCH 0/4] ath10k: rename mesh and add abstraction layer
References: <1453920957-9908-1-git-send-email-poh@qca.qualcomm.com> <20160127193955.GC12639@localhost> <56A93C56.5070205@codeaurora.org> <CAEFj984ULyZNa5YcLXZngrsYNT43WZCX5CHJLZ5msfHMmNABdg@mail.gmail.com>
In-Reply-To: <CAEFj984ULyZNa5YcLXZngrsYNT43WZCX5CHJLZ5msfHMmNABdg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 01/27/2016 06:04 PM, Yeoh Chun-Yeow wrote:
> On Thu, Jan 28, 2016 at 5:53 AM, Peter Oh <poh@codeaurora.org> wrote:
>> On 01/27/2016 11:39 AM, Bob Copeland wrote:
>>> On Wed, Jan 27, 2016 at 10:55:53AM -0800, Peter Oh wrote:
>>>> Split Mesh service to 11s Mesh and non-11s Mesh according to
>>>> firmware service bit to help users distinguish 11s Mesh from
>>>> non 11s Mesh.
>>>> And add abstraction layer for vdev subtype to solve subtype mismatch
>>>> and to give flexible compatibility among different firmware revisions.
>>> Out of curiosity, which non-11s mesh, if you can share?
>> non-11s Mesh can be anything, but 11s Mesh such as meraki mesh.
>>
> I thought that non-11s mesh is for meraki mesh since it is not 802.11s
> implementation.
>
> WMI_10_4_SERVICE_MESH_NON_11S for non IEEE802.11s Mesh
> WMI_SERVICE_MESH_11S and WMI_VDEV_SUBTYPE_MESH for IEEE 802.11s Mesh
>
> Correct me if I am wrong.
You're correct.  WMI_VDEV_SUBTYPE_MESH -> WMI_VDEV_SUBTYPE_MESH_11S
>
> Thanks
>
> ----
> Chun-Yeow
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k

