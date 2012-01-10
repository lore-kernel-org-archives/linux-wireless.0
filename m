Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab2AJXa6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 18:30:58 -0500
Subject: Re: linux 3.2-rcX iwlwifi driver's problem (wifi link unstable
 when moving between multiple APs)
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Cheng Renquan <crquan@gmail.com>
Cc: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CAH5vBdKwQ3vPr01PiRMmUqARK4CE44vM9WeVSx-QydpDLQtT1A@mail.gmail.com>
References: <CAH5vBdJLHkFLQCHHYOczXQt1Hwwe3e-Ct0MUjyTRU0vgodAPOg@mail.gmail.com>
	 <1324424765.13074.281.camel@wwguy-huron>
	 <CAH5vBdKotiPqpHV=tx2fv8=-HRBuJnYe8wEAF2Z9xH3zVnwyqg@mail.gmail.com>
	 <CA+icZUXWccU-TtwE7b7Mm9Nw7juQwDxvYRZfOdjP3q1O-Mr0Ug@mail.gmail.com>
	 <CAH5vBdKtV1Ydb2ffBVDxdynsF9S14Ddy6XezHzXvRC3bRC-huQ@mail.gmail.com>
	 <CA+icZUXDOxNo-Y9d2WcdhMZyDJeCT69z340xMwNiN9hbq0XAFA@mail.gmail.com>
	 <CAH5vBdLq6zOagjmyM1h9Jon+fYnz5t05Dx7u6VqOWGHna+M3_Q@mail.gmail.com>
	 <CA+icZUVixfk0h1ENU-tWMS5hgurbEV4jYpYNWbzaxCUx_b64UQ@mail.gmail.com>
	 <CAH5vBdK62juwC_qPPTfmgFkMp9XMy+3j1YLvBSxBc+zr9_oBJQ@mail.gmail.com>
	 <CA+icZUUhg91UAPMRGgXYAvo6wkr5ogb+vW8SsB28BeUP_6-g6w@mail.gmail.com>
	 <1324484074.13074.313.camel@wwguy-huron>
	 <CAH5vBdJ4-33z3FbOwVG1QRzfFOwFpz1wccbQNDXEC6-NhBa31A@mail.gmail.com>
	 <1324518057.4755.4.camel@wwguy-ubuntu>
	 <CAH5vBdKwQ3vPr01PiRMmUqARK4CE44vM9WeVSx-QydpDLQtT1A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Jan 2012 14:27:08 -0800
Message-ID: <1326234428.13074.385.camel@wwguy-huron> (sfid-20120111_003102_459210_E13EE549)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Cheng,

On Tue, 2012-01-10 at 15:17 -0800, Cheng Renquan wrote:
> I've upgraded to Linux 3.2 and roaming failed randomly again,
> 
> after the failure it may recover
> sometimes by switch off and on the wifi button on laptop,
> sometimes by "modprobe -r iwlwifi && modprobe iwlwifi",
> sometimes by "stop networkmanager and start networkmanager",
> sometimes recover automatically 10 or 20 minutes later,
> sometimes never recover, infinitely looping (can only move to other
> place, but same place has good wifi coverage verified by other
> colleagues, win/mac users)
> 
> 
> have checked it has your recent 78feb35 & 81670a4 commits,
> $ git log -n5 --no-merges --oneline v3.2 -- drivers/net/wireless/iwlwifi/
> 96f1f05 iwlwifi: update SCD BC table for all SCD queues
> 78feb35 iwlwifi: allow to switch to HT40 if not associated
> 81670a4 iwlwifi: tx_sync only on PAN context
> 123877b iwlwifi: do not set the sequence control bit is not needed
> 9995ffe iwlwifi: change the default behavior of watchdog timer
> 
Are you saying without those two commits (78feb35 & 81670a4), the
roaming works?

Thanks
Wey 


