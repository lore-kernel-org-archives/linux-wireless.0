Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:64910 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab2EUMhG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2012 08:37:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAFub=KS1_Bj=b2OVTf33VHtQ7BKY2k3Wd1oGwmVVJNgbexZ=6w@mail.gmail.com>
References: <CAFub=KS1_Bj=b2OVTf33VHtQ7BKY2k3Wd1oGwmVVJNgbexZ=6w@mail.gmail.com>
Date: Mon, 21 May 2012 15:37:05 +0300
Message-ID: <CAFub=KRqU1cA1cEwUvbkUCgEtY2yVzY+8tE+cPSL7u0m+yqAWA@mail.gmail.com> (sfid-20120521_143714_212507_3D8184C9)
Subject: scripts in compat tree
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

(Resending as plain-text, sorry for the duplication in lf_driver_backports list)

I will be working on the GSoC project to prepare compat graphics drivers.

Looking at the scripts (ckmake and get-compat-kernels) in the compat
tree, I see that they are only handling Ubuntu systems. First of all,
should they really be distro-aware? Why not to download the tarballs
from kernel.org? Isn't it a more generic approach?

If this makes sense, I'd like to extend those scripts to handle
vanilla kernels with a cmdline switch which won't care at all about
lsb_release. I will hardcode end-of-life products and parse kernel.org
to dynamically detect new versions, download and extract them under
/lib/modules if they don't exist in there, etc.

I'm waiting for your feedback :)

--
Ozan Çağlayan
