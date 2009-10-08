Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f203.google.com ([209.85.212.203]:57103 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbZJHSQa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 14:16:30 -0400
Received: by vws41 with SMTP id 41so3351036vws.4
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2009 11:15:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ACBF821.8030508@cmu.edu>
References: <43e72e890910061721o5f78f82cvfaa216a4d887e4f8@mail.gmail.com>
	 <4ACBF821.8030508@cmu.edu>
Date: Thu, 8 Oct 2009 14:15:53 -0400
Message-ID: <b6c5339f0910081115u3d6aea09l8ed8c104e7e6d2b4@mail.gmail.com>
Subject: Re: [ath5k-devel] Regarding changing channel widthlin
From: Bob Copeland <me@bobcopeland.com>
To: Aditya Bhave <aybhave@cmu.edu>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 6, 2009 at 10:08 PM, Aditya Bhave <aybhave@cmu.edu> wrote:
> Is there any detailed documentation on the internals of ath5k code?
>
> 1. Description of the data structures
> 2. Flow-diagram of function calls
> 3. What register is used for what aspect of WiFi etc etc

Nope (I think you'll find this is true of most/all drivers).

Most of the intelligence is in the upper layers (mac80211), which are
documented on http://wireless.kernel.org/.  Most of the work to enable
it will be in those layers, as Luis said.  BTW search the list, several
people have proposed ideas for an infrastructure for channel width
setting.

-- 
Bob Copeland %% www.bobcopeland.com
