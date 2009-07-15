Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:44471 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbZGOWL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 18:11:56 -0400
Received: by gxk9 with SMTP id 9so2758108gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2009 15:11:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0907151451r2ae9e3bcvcafd921b300fb040@mail.gmail.com>
References: <4A5E377E.6090705@redfish-solutions.com> <b6c5339f0907151451r2ae9e3bcvcafd921b300fb040@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Date: Wed, 15 Jul 2009 15:11:36 -0700
Message-ID: <43e72e890907151511h67250c08y373a145fab7b4b7a@mail.gmail.com>
Subject: Re: Build instructions for cross-compilation environment
To: Bob Copeland <me@bobcopeland.com>
Cc: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 15, 2009 at 2:51 PM, Bob Copeland<me@bobcopeland.com> wrote:
> On Wed, Jul 15, 2009 at 4:09 PM, Philip A.
> Prindeville<philipp_subx@redfish-solutions.com> wrote:
>> Also, a list of what CONFIG_xxx symbols I need to turn off to ensure
>> that there is no "residue" left over from the kernel build to interfere
>> with the compat-wireless build would be helpful (or alternatively,
>> what's the bare essential list of CONFIG_xxx symbols that need to be
>> enabled to "hook" compat-wireless into an existing kernel).
>
> At least CONFIG_{CFG80211,MAC80211}=m but you'll likely need to experiment.

I take it you mean on your currently running kernel?

Your own kernel requirements aren't dramatic. Its actually very
simple. Enable networking (duh), PCI if you want PCI drivers, USB if
you want USB drivers, etc.

Wext is now optional but IIRC I haven't removed that requirement from
compat-wireless. So for now enable that.

  Luis
