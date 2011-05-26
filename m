Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3139 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757947Ab1EZSqh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 14:46:37 -0400
Message-ID: <4DDE9FFE.2030407@broadcom.com> (sfid-20110526_204640_803211_907ABF23)
Date: Thu, 26 May 2011 20:46:22 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Daniel Halperin" <dhalperi@cs.washington.edu>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>
Subject: Re: %d in wlan log messages
References: <4DDE63B4.4030309@broadcom.com>
 <BANLkTina0R-SJamJ_GFbxJsYcvvdyxzZNg@mail.gmail.com>
 <4DDE9391.6020302@broadcom.com> <20110526175553.GE3595@tuxdriver.com>
In-Reply-To: <20110526175553.GE3595@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/26/2011 07:55 PM, John W. Linville wrote:
> On Thu, May 26, 2011 at 07:53:21PM +0200, Arend van Spriel wrote:
>>
>> Weird. I did not change anything in udev rules (using Ubuntu 10.10
>> over here). So the only variant in my setup is move to 2.6.39. Can
>> you explain that netdev apparently has the proper interface id (see
>> timestamp [563.177019] above?
> Wasn't a problem like this recently reported w/ compat-wireless?
> And the fix was to backport some patch to the networking core?
> I could be hallucinating again...

Does it happen often then? ;-)

> Is it possible that you somehow have a "dirty" build?  Could you try
> doing a 'make clean' and rebuilding?

Ok. I thought I did a distclean before building, but let me try.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


