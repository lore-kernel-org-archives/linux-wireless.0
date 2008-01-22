Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17069 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYAVUWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 15:22:08 -0500
MIME-Version: 1.0
Subject: RE: [ipw3945-devel] iwl3945 rfkill regression
Date: Tue, 22 Jan 2008 22:21:58 +0200
Message-ID: <C07C4589BE74A34981C3C3525EE1F8010338CB49@hasmsx412.ger.corp.intel.com> (sfid-20080122_202216_079704_C692B651)
In-Reply-To: <f6ca9fed0801221212k709f04dbx1f81cab4c724996a@mail.gmail.com>
References: <f6ca9fed0801221204j71ad2137l19555363e46a7e45@mail.gmail.com> <C07C4589BE74A34981C3C3525EE1F8010338CB35@hasmsx412.ger.corp.intel.com> <f6ca9fed0801221212k709f04dbx1f81cab4c724996a@mail.gmail.com>
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "drago01" <drago01@gmail.com>
Cc: "ipw3945-devel" <ipw3945-devel@lists.sourceforge.net>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



>-----Original Message-----
>From: drago01 [mailto:drago01@gmail.com]
>Sent: Tuesday, January 22, 2008 10:12 PM
>To: Winkler, Tomas
>Cc: ipw3945-devel; Cahill, Ben M; Zhu, Yi; linux-wireless
>Subject: Re: [ipw3945-devel] iwl3945 rfkill regression
>
>On Jan 22, 2008 9:07 PM, Winkler, Tomas <tomas.winkler@intel.com>
wrote:
>>
>> I believe it's delaying uCode load to mac_start - still need to be
>> polished.
>
>ok, thx for the quick reply.
>If you have any potential fixes I would be happy to test them ;)

Can you get me the sequence it is happening? RF kill switch is off
before you power up the laptop or after, during association or in
unassociated state..etc
Thanks

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

