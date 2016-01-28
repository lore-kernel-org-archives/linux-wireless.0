Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34979 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbcA1CEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 21:04:41 -0500
Received: by mail-oi0-f68.google.com with SMTP id r14so48198oie.2
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2016 18:04:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56A93C56.5070205@codeaurora.org>
References: <1453920957-9908-1-git-send-email-poh@qca.qualcomm.com>
	<20160127193955.GC12639@localhost>
	<56A93C56.5070205@codeaurora.org>
Date: Thu, 28 Jan 2016 10:04:40 +0800
Message-ID: <CAEFj984ULyZNa5YcLXZngrsYNT43WZCX5CHJLZ5msfHMmNABdg@mail.gmail.com> (sfid-20160128_030445_184164_4CD0EA59)
Subject: Re: [PATCH 0/4] ath10k: rename mesh and add abstraction layer
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Peter Oh <poh@codeaurora.org>
Cc: Bob Copeland <me@bobcopeland.com>, Peter Oh <poh@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 28, 2016 at 5:53 AM, Peter Oh <poh@codeaurora.org> wrote:
>
> On 01/27/2016 11:39 AM, Bob Copeland wrote:
>>
>> On Wed, Jan 27, 2016 at 10:55:53AM -0800, Peter Oh wrote:
>>>
>>> Split Mesh service to 11s Mesh and non-11s Mesh according to
>>> firmware service bit to help users distinguish 11s Mesh from
>>> non 11s Mesh.
>>> And add abstraction layer for vdev subtype to solve subtype mismatch
>>> and to give flexible compatibility among different firmware revisions.
>>
>> Out of curiosity, which non-11s mesh, if you can share?
>
> non-11s Mesh can be anything, but 11s Mesh such as meraki mesh.
>

I thought that non-11s mesh is for meraki mesh since it is not 802.11s
implementation.

WMI_10_4_SERVICE_MESH_NON_11S for non IEEE802.11s Mesh
WMI_SERVICE_MESH_11S and WMI_VDEV_SUBTYPE_MESH for IEEE 802.11s Mesh

Correct me if I am wrong.

Thanks

----
Chun-Yeow
