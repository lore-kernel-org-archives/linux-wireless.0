Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.comnets.rwth-aachen.de ([137.226.4.160]:33333 "EHLO
	gin.comnets.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754483AbXKNAjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 19:39:16 -0500
Message-ID: <473A43AF.6050207@ieee.org> (sfid-20071114_003919_157739_C32ADA99)
Date: Wed, 14 Nov 2007 01:39:11 +0100
From: "Guido R. Hiertz" <hiertz@ieee.org>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Javier Cardona <javier@cozybit.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/4] o80211s: (mac80211s) basic mesh interface support
References: <473516ee.26d7720a.3f57.ffff8233@mx.google.com>	 <1194689500.7258.61.camel@johannes.berg>	 <445f43ac0711101603s18cd70a7lb70dedea8cc5c3c0@mail.gmail.com>	 <1194866072.5229.8.camel@johannes.berg>	 <445f43ac0711131231s5bfd173v1c9105e9f23d83b2@mail.gmail.com> <1194986213.28937.10.camel@localhost.localdomain>
In-Reply-To: <1194986213.28937.10.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

>> Anyway, I see no problem in renaming this IEEE80211_IF_TYPE_MESH_POINT
>> (even though I just heard of a proposal to rename Mesh Points as Mesh
>> Stations... )
> 
> How concrete is that?

Well ... I have plans to propose to change some terminology.

> It could obviously be changed later but best to keep the code
> terminology consistent with the standards terminology unless the
> standards terminology is completely wack.

Please consider that 802.11s had tremendous changes since 2003. While 
the original PAR discussed meshing of APs only, the revised PAR is much 
broader and considers meshing of 802.11 devices in general.

Therefore, some of our old terminology doesn't really fit any longer. 
Furthermore, the adoption of 802.11 terms for single-hop case often 
confuses people when being used in the context of a mesh network. It's 
always painful when the 802.11s task group wastes time because people 
have different understanding of the words the use ...

Best regards,

Guido

-- 
Dipl.-Ing. Guido R. Hiertz      | mailto:grh@comnets.rwth-aachen.de
Chair of Communication Networks | http://www.comnets.rwth-aachen.de/~grh
RWTH Aachen University          | Phone: +49 241 802 5829
