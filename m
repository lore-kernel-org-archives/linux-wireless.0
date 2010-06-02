Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f185.google.com ([209.85.222.185]:58791 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab0FBCUp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 22:20:45 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 1 Jun 2010 19:20:25 -0700
Message-ID: <AANLkTinuODBgl8Yqntq29BhBms8S17BuRRAx72UoJaV2@mail.gmail.com>
Subject: compat-wireless branch for wireless-testing, "wl"
To: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some developers or users may not have linux-next.git or the
linux-2.6-allstable.git trees around and only keep a local
wireless-testing.git tree around. For those there is a branch now on
compat-wireless called "wl" (I got it from the localversion-wireless
file) which you can use to generate tarballs based on only the latest
wireless-testing updates. I've kept the pending and crap patches on it
for now but those will likely be removed once John starts merging
stuff back in.

I would prefer if people who do contribute on compat-wireless work
more on the master branch of compat-wireless and linux-next.git
instead though as this allows us to start backporting the next kernel
release headaches early on and not at cram time during or right after
the merge window. The "wl" branch is there to aid developers who do
not have the linux-next.git tree around or for Linux distributions who
currently may not care about updates on the kernel development cycle
on the other subsystems since wireless-testing only gets only 802.11
updates. An example is openwrt which uses only wireless-testing.git.

If you send me patches I will assume they are for the master branch of
compat-wireless unless otherwise specified. I will try to keep it the
wireless-testing branch updated but patches for it are always
welcomed. I will try to follow the upstream model though so would
first want the patches on the master branch of compat-wireless and
only then trickle them down for the "wl" branch. Since there is a time
delay between patches getting in wireless-next.git and linux-next.git
there may be an inherent delay between propagating patches down to the
"wl" branch. Not sure, we'll see. If you have a better idea of how to
handle this please let me know.

  Luis
