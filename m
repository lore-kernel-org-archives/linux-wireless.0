Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:37122 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752997AbcKTBIe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Nov 2016 20:08:34 -0500
Received: by mail-it0-f41.google.com with SMTP id y23so78019389itc.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2016 17:08:34 -0800 (PST)
Date: Sat, 19 Nov 2016 20:07:40 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Matteo Grandi <iu5bdp@gmail.com>
Cc: LinuxWireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: ath10k stuck in mesh mode
Message-ID: <20161120010740.GB3581@localhost> (sfid-20161120_020912_826282_932EBA07)
References: <CAHdg3xaCnAp8rgMs3mVYvV6TFadNjwBtCo+rpHgH_-L8JUo-dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHdg3xaCnAp8rgMs3mVYvV6TFadNjwBtCo+rpHgH_-L8JUo-dw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2016 at 10:43:06PM +0100, Matteo Grandi wrote:
> So the question is: who decide if use MIMO and higher MCS hopefully on
> 80MHz channel or not? Is the firmware? Is there a way to force the
> interface to use 80MHz and/or MIMO? (iw provide the possibility to
> choose between [HT20/HT40-/HT40+]).

You can specify the channel width like so:

iw dev wlan0 set freq 5745 80 5775
iw dev wlan0 mesh join mesh-vht

-- 
Bob Copeland %% http://bobcopeland.com/
