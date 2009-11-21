Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f204.google.com ([209.85.216.204]:41336 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbZKUQpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Nov 2009 11:45:30 -0500
Received: by pxi42 with SMTP id 42so2421059pxi.5
        for <linux-wireless@vger.kernel.org>; Sat, 21 Nov 2009 08:45:36 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 21 Nov 2009 08:45:36 -0800
Message-ID: <70f6a1ed0911210845s5dd46374ie74e6e105433dcae@mail.gmail.com>
Subject: Using wireless-testing tree
From: Duy Nguyen <dnlove@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone, I downloaded and upgraded my kernel with wireless-testing
tree.  I have some questions.

1) I create my own git branch and modify only the mac80211 and
ath5k/ath9k.  How do I compile only these modules and test them
without having  to recompile and upgrade my whole kernel again.
Because of the repetitive nature of modifying and testing drivers, I
am trying to avoid this but is it possible?  Or compat-wireless is a
better alternative.

2) I have compat-wireless-2.6 tree in my wireless-testing tree.  I
still don't know how to create my own compat-wireless even after going
through the wiki online.
cd compat-wireless-2.6
make
but it complains about some errors.

I am just wondering if you could share your most efficient ways
working with wireless-testing tree.   Thanks.

Duy
