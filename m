Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47844 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161941AbcA0V4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 16:56:10 -0500
Message-ID: <56A93C56.5070205@codeaurora.org> (sfid-20160127_225656_338377_D5A24330)
Date: Wed, 27 Jan 2016 13:53:26 -0800
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>, Peter Oh <poh@qca.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] ath10k: rename mesh and add abstraction layer
References: <1453920957-9908-1-git-send-email-poh@qca.qualcomm.com> <20160127193955.GC12639@localhost>
In-Reply-To: <20160127193955.GC12639@localhost>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 01/27/2016 11:39 AM, Bob Copeland wrote:
> On Wed, Jan 27, 2016 at 10:55:53AM -0800, Peter Oh wrote:
>> Split Mesh service to 11s Mesh and non-11s Mesh according to
>> firmware service bit to help users distinguish 11s Mesh from
>> non 11s Mesh.
>> And add abstraction layer for vdev subtype to solve subtype mismatch
>> and to give flexible compatibility among different firmware revisions.
> Out of curiosity, which non-11s mesh, if you can share?
non-11s Mesh can be anything, but 11s Mesh such as meraki mesh.
>

