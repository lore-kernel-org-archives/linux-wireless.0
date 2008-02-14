Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:2903 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbYBNPp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 10:45:28 -0500
Received: by py-out-1112.google.com with SMTP id u52so459799pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2008 07:45:27 -0800 (PST)
Message-ID: <43e72e890802140745pe2eeef3k5be35f842802226f@mail.gmail.com> (sfid-20080214_154533_950984_414BE437)
Date: Thu, 14 Feb 2008 10:45:26 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: madwifi is not fully open source
Cc: "Holger Schurig" <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080212141731.GB3051@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <57314e840802111427i7e8d00capbe430727faff78a1@mail.gmail.com>
	 <1202770112.6824.35.camel@localhost.localdomain>
	 <57314e840802120045h6e6960d8jde5657da8aff0e3e@mail.gmail.com>
	 <200802121013.47142.hs4233@mail.mn-solutions.de>
	 <20080212141731.GB3051@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 12, 2008 at 9:17 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Tue, Feb 12, 2008 at 10:13:47AM +0100, Holger Schurig wrote:
>
>  > 4. write the driver for Windows in the usual, close source
>  >    form, "leak" or give docs to some Linux developers and
>  >    let they write the driver for the device. FCC can't object,
>  >    you didn't wrote the driver :-)
>
>  "FCC can't object"...this is only true to a point.  Sure, AFAIK the
>  FCC can do nothing to discipline the software developer in question.
>  However, the FCC retains broad discretionary authority over the
>  hardware manufacturer.  So if a driver appeared that enabled "bad
>  things" to happen with certain hardware, regulators might revoke
>  that device's certification.  This would be very expensive for a
>  manufacturer and is the root of all wireless vendor non-cooperation.
>
>  FWIW, my opinion is that this should be resolvable from a business
>  perspective.  The existence of an open source driver should represent
>  a quantifiable financial risk -- a risk that is already present
>  in some form anyway due to the existence of people with reverse
>  engineering skills.  Any decent business is good at managing risk,
>  and any number of (re-)insurance firms exist to handle the finances
>  involved with that.  It seems to me that a business should be able to
>  insure against potential losses at a rate that is more than offset by
>  the gains of being strong in the burgeoning Linux market.  Of course,
>  if I were a brilliant business man...well, YMMV... :-)

Warning: IANAL

I'd think all modern wireless companies would incur a potential risk
then -- whether they support FOSS or not. So I'd think most companies
would need this insurance right now.

But lets talk some common sense. SDRs are driving the industry,
whether they are certified under part 15 rules or not as even firmware
can be reversed engineered. This and the fact that I see pure SDRs
(GNU Radio) are being used in the latest wireless research [1] seems
to indicate they are the wave of the future and we should simply focus
on trying to enhance regulatory bodies instead of ignoring the issue.

Now when I rent a car and move it out of the company's lot I could
technically just drive in a rush and run over a lot of people at the
local Starbucks, lets say being heavily inspired after playing Grand
Theft Auto. Legally I am responsible, not the Car rental company and
maybe not even the game maker company which provided inspiration.

Common sense tells me that it is very silly that wireless companies or
their direct-customers (OEMs) could be held liable for use of
unsupported drivers or modified drivers which make their hardware
behave in manners in which they were not intended for. IMHO the person
who makes the device operate out-of-bounds of the supported or
acceptable legal regulatory laws should be held liable, not the
company -- as would be the case if I go off in a driving rampage with
my next car rental. That piece of legislation is what I think needs
updating instead of playing along the the more proven-incorrectly
security-by-obscurity approach that some vendors have followed after
interpretation of regulatory laws. Because anyway if certifying under
part 15 rules my interpretation is you are certifying the hardware and
not the software so -- AFAICT this certification is software agnostic.
If we want to talk about not being able to support the software then
lets talk about SDRs as those are the rules that apply when strictly
leaving software to handle a fine grain level of hardware operation.

There is a common problem in the wireless industry and that is fear of
getting labelled under SDR. Stop being afraid and use common sense.
And yes, of course, its easy for me to say that as I don't have a
wireless business or am part of of one. But I have previously made
suggestions as to how to sanely work through this problem in the short
term and in the long run. In the short term embrace a central
regulatory domain agent in the Operating System and in the long run
help shape legislation to pave the way for SDRs, in ways that actually
makes sense, not just out of fear.

Let me also remind you a section of GPLv2 perhaps overlooked:

    "This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details."

Now quoting directly from GPLv2  preamble[2] :

    "Also, for each author's protection and ours, we want to make certain
    that everyone understands that there is no warranty for this free
    software.  If the software is modified by someone else and passed on, we
    want its recipients to know that what they have is not the original, so
    that any problems introduced by others will not reflect on the original
    authors' reputations."

So you can do what you can but offer no warranty for it, you can stand
behind what is in place and patches that lie ahead for your driver.

[1] http://orbit-lab.org/wiki/Documentation/GNURadio
[2] http://www.fsf.org/licensing/licenses/info/GPLv2.html

  Luis
