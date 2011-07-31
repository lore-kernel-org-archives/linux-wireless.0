Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57352 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1GaQsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jul 2011 12:48:47 -0400
Received: by wyg8 with SMTP id 8so1106436wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 31 Jul 2011 09:48:46 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 31 Jul 2011 11:48:46 -0500
Message-ID: <CAJ8GFOg4A4JwC8qdF6e7rRCRETnfrPm5Zv60_8Cm1xpbJJNQpg@mail.gmail.com> (sfid-20110731_184851_677442_BC23B91A)
Subject: carl9170: How do I change value of retries for long packets?
From: Harshal Chhaya <harshal@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Christian - thanks for the pointer to the function that sets the keys
on the AR9170. I am still figuring out how to use 64 clients with h/w
encryption on the AR9170 - enabling debug/tracing in my build isn't as
straightforward as suggested by the wiki.

However, I did find some very helpful information in the debug files
in 'debugfs' including the number of retries.
The current value is 4 for long packets and 7 for short packets.

I think the small # of retries for regular data packets may be one
reason why I am seeing some throughput problems at longer ranges.

How do I change the number of retries for long packets? Is this a
build-time configuration or can I change it at run-time?

Thanks,
- Harshal
