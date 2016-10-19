Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:46388 "EHLO smtp3-1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943678AbcJSPCR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:02:17 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: sequence diagrams in rst documentation
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <87eg3dvhdi.fsf@intel.com>
Date: Wed, 19 Oct 2016 17:02:00 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-wireless@vger.kernel.org,
        linux-doc <linux-doc@vger.kernel.org>
Message-Id: <40E20C55-88BE-4639-9901-E4073A07713B@darmarit.de> (sfid-20161019_170237_814341_E67165B7)
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net> <20161011072119.7ad4e3a3@lwn.net> <1476193466.4118.10.camel@sipsolutions.net> <1476194038.4118.11.camel@sipsolutions.net> <1476791021.6425.25.camel@sipsolutions.net> <B9AC83F3-AA14-414B-B538-81436620E432@darmarit.de> <1476799968.6425.33.camel@sipsolutions.net> <87eg3dvhdi.fsf@intel.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Am 18.10.2016 um 16:52 schrieb Jani Nikula <jani.nikula@linux.intel.com>:

>> *Only* adding the PNG would be awful, I'd have to keep track of the
>> corresponding source elsewhere, and perhaps couldn't even GPL it
>> because then I couldn't distribute the PNG without corresponding
>> source...
>> 
>> Adding the source text would really be the only practical choice, but
>> doing so makes it easy to mismatch things, and also very easy to use
>> proprietary services for it that may go away at any time, etc.
> 
> Agreed. And there are other problems with attaching binaries (although
> I'd say we should fix them too) [1].
> 
> [1] http://lkml.kernel.org/r/02a78907-933d-3f61-572e-28154b16b9e5@redhat.com

Hmm, I was not briefed that binaries are problematic. I have seen
GIFs e.g. [2] and PDFs with a long history (when I worked with the media
documentation), so I thought binaries are OK.

Can you give me some more hints to understand in what ways they are
problematic?  / sorry if my question seems dump /

[2] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/Documentation/DocBook/v4l/fieldseq_tb.gif?h=v3.0

-- Markus --
