Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from flpi195.sbcis.sbc.com ([207.115.20.197]:44335 "EHLO
	flpi195.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbXKUA0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 19:26:34 -0500
Date: Tue, 20 Nov 2007 16:25:04 -0800 (PST)
From: Asheesh Laroia <asheesh@asheesh.org>
To: Andreas Schwab <schwab@suse.de>
cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH v3] remove bcm43xx
In-Reply-To: <jeve7xc6sm.fsf@sykes.suse.de>
Message-ID: <alpine.DEB.0.9999.0711201621120.9468@dell.linuxdev.us.dell.com> (sfid-20071121_002636_945137_A6B0A170)
References: <20071119202121.6ad3fa70@morte> <200711201507.46998.mb@bu3sch.de> <je4pfhdn2c.fsf@sykes.suse.de> <200711201520.05718.mb@bu3sch.de> <jeve7xc6sm.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 20 Nov 2007, Andreas Schwab wrote:

> Michael Buesch <mb@bu3sch.de> writes:
>
>> On Tuesday 20 November 2007 15:11:07 Andreas Schwab wrote:
>>> Michael Buesch <mb@bu3sch.de> writes:
>>>
>>>> On Monday 19 November 2007 23:36:44 Andreas Schwab wrote:
>>>>> b43 still does not work at all on ppc.
>>>>
>>>> This is absolutely _wrong_.
>>>
>>> Of course it is wrong, but apparently the only way to get attention to a
>>> blocker bug.
>>
>> I didn't hear about your bug before.
>>
>> Are you using latest driver from wireless-2.6 and the officially
>> supported firmware version from
>> http://www.linuxwireless.org/en/users/Drivers/b43
>
> I have now downgraded the firmware (I was foolishly assuming that all
> firmware versions recognized by b43-fwcutter are equally supported), and
> the error does not occur any more.  Thanks for your help.

It sounds like b43-fwcutter will extract firmware that is not maximally 
compatible with the b43 driver.  If that's right, then it would be way 
nice to print a notice to the user that he's extracting a 
less-than-perfectly-supported firmware.

Yes, I'm willing to write this patch if people will point me to a table of 
which firmware is maximally-supported.  (If someone else writes it 
instead, I'd prefer that, but if no one will then I can.)

I haven't actually been using a bcm43xx chip for wireless for about a 
year, but I've been enjoying the list mail so I stayed on and read mails 
casually.  It sounds like there's one specific firmware that's 
recommended; if so, then printing "Congratulations, you're using the 
best-supported firmware as of ${RELEASE_DATE_OF_THIS_FWCUTTER}" in that 
case would be easy, as well as "Warning! You're not using the 
best-supported firmware as of ${RELEASE_DATE_OF_THIS_FWCUTTER}".

If it already does that now, then sorry for the noise!

-- Asheesh.

--
Positive, adj.:
 	Mistaken at the top of one's voice.
 		-- Ambrose Bierce, "The Devil's Dictionary"
