Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:58614 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbaD1HKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2014 03:10:54 -0400
Received: by mail-oa0-f53.google.com with SMTP id j17so6903063oag.12
        for <linux-wireless@vger.kernel.org>; Mon, 28 Apr 2014 00:10:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <535A13FA.4070405@gmail.com>
References: <CA+V6dmjwfsrDSDQWHHCFbW9L14GnzifoSjH5UOS4zTSusRtYow@mail.gmail.com>
 <535A13FA.4070405@gmail.com>
From: Pierre Bourdon <delroth@gmail.com>
Date: Mon, 28 Apr 2014 09:10:33 +0200
Message-ID: <CA+V6dmjNF2cgQHx=bZBDUrBUocYVzqQEmB5d13UhU-C9tTAydw@mail.gmail.com> (sfid-20140428_091123_047273_D7392690)
Subject: Re: Odd network behaviors with an Intel Wireless 7260
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ryan Houdek <sonicadvance1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 25, 2014 at 9:51 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> Thank you very much for this very detailed report.
> 1) can you try with power save disabled?
>    sudo iw wlan0 set power_save off
> 2) if 1) helps, can you try https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/iwlwifi-fixes.git/commit/?id=a82dda6cd492b8c88952be6f6527f3656f7ac585.

Unfortunately I have to report that this does not solve the issue. I
was able to reproduce the random non-local drops several times with
power saving disabled on the interface.

-- 
Pierre "delroth" Bourdon <delroth@gmail.com>
Software Engineer @ Zürich, Switzerland
http://code.delroth.net/
