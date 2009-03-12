Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.188]:30683 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZCLVcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 17:32:48 -0400
Received: by gv-out-0910.google.com with SMTP id c6so572945gvd.37
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 14:32:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1236893111.30325.10.camel@maxim-laptop>
References: <1236728344.26432.26.camel@maxim-laptop>
	 <d94c510d0903110115s620c7851g391fcf00e644a113@mail.gmail.com>
	 <b6c5339f0903120714rda8ec3ev2c2fbfaaf0b21351@mail.gmail.com>
	 <1236893111.30325.10.camel@maxim-laptop>
Date: Thu, 12 Mar 2009 17:32:44 -0400
Message-ID: <b6c5339f0903121432h26d71d6nd901f12d0c10e7bc@mail.gmail.com> (sfid-20090312_223252_963519_AF1ACE71)
Subject: Re: [ath5k-devel] Thanks for TX power patch
From: Bob Copeland <me@bobcopeland.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mick@madwifi-project.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 12, 2009 at 5:25 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> Just to be clear, I got oopses, and hangs after resume from disk by just
> using compat-wireless-2009-03-10 _without_ Nick's patches.

Interesting, I thought you said that, but I tried the same stuff on
plain wireless testing and didn't have any problems.

The eeprom stuff was definitely implicated in my 1 sec modprobe + rmmod
test.

-- 
Bob Copeland %% www.bobcopeland.com
