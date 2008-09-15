Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:44468 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbYIOXYO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 19:24:14 -0400
Received: by gxk9 with SMTP id 9so26200752gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 16:24:13 -0700 (PDT)
Message-ID: <43e72e890809151624g3540f308r90808e281b22314e@mail.gmail.com> (sfid-20080916_012418_151969_7099EB3F)
Date: Mon, 15 Sep 2008 16:24:13 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Subject: Re: [RFC] mac80211: re-enable aggregation on 2.6.27
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890809151555u3a79bd89h763fa0a6ba07e752@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1221503192-28502-1-git-send-email-lrodriguez@atheros.com>
	 <43e72e890809151555u3a79bd89h763fa0a6ba07e752@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 15, 2008 at 3:55 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:

With iwlagn (Intel 4965) on HT40 5GHz using iperf over TCP I get much
more convincing results (still noisy environment):

mcgrof@pogo ~ $ iperf -s -i1
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.1.5 port 5001 connected with 192.168.1.3 port 41403
[  4]  0.0- 1.0 sec  3.61 MBytes  30.3 Mbits/sec
[  4]  1.0- 2.0 sec  1.88 MBytes  15.8 Mbits/sec
[  4]  2.0- 3.0 sec  7.56 MBytes  63.4 Mbits/sec
[  4]  3.0- 4.0 sec  11.4 MBytes  96.0 Mbits/sec
[  4]  4.0- 5.0 sec  10.2 MBytes  85.3 Mbits/sec
[  4]  5.0- 6.0 sec  10.4 MBytes  87.0 Mbits/sec
[  4]  6.0- 7.0 sec  10.3 MBytes  86.5 Mbits/sec
[  4]  7.0- 8.0 sec  10.6 MBytes  88.9 Mbits/sec
[  4]  8.0- 9.0 sec  10.3 MBytes  86.5 Mbits/sec
[  4]  9.0-10.0 sec  10.6 MBytes  89.0 Mbits/sec
[  4]  0.0-10.2 sec  88.6 MBytes  73.1 Mbits/sec

  Luis
