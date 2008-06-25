Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:36006 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbYFYRnp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 13:43:45 -0400
Message-ID: <4862840F.4030409@lwfinger.net> (sfid-20080625_194348_222644_9F28ED25)
Date: Wed, 25 Jun 2008 12:44:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linville@tuxdriver.com, hintak_leung@yahoo.co.uk,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] rtl8187: Realtek 8187B wireless support with product	id0x8197/0x8189
References: <4862796a.pmrQX9GXIZ1wDm2k%Larry.Finger@lwfinger.net> <1214415411.7901.25.camel@dv>
In-Reply-To: <1214415411.7901.25.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Wed, 2008-06-25 at 11:59 -0500, Larry.Finger@lwfinger.net wrote:
> 
>> I have a few questions during the porting:
>>
>> - control->queue, which the herton's change used, for switching between 4
>> tramission queue at end point 6,7,5,4, has disappeared. I hard-coded 6 in
>> this version, (see commemt #37 for background), but what's the correct
>> way to do this in current wireless-2.6 code?
> 
> Where did you do it?  The patch you posted uses skb_get_queue_mapping.

I just took care of the checkpatch errors and warnings and submitted 
the patch. Obviously, that section needs to be changed.

>> The original message from Herton follows:
>>
>> I'm posting this patch mostly to share my results so far and take that
>> burden from me.  I have no desire to take over maintenance of that
>> driver or to answer any support requests.
> 
> I wrote that.

I realize that now. I'll fix that. Is it OK that there is a 
"Signed-off-by" for you?

Larry

