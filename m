Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:20469 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbXBPM0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 07:26:21 -0500
Received: by nf-out-0910.google.com with SMTP id o25so1503129nfa
        for <linux-wireless@vger.kernel.org>; Fri, 16 Feb 2007 04:26:20 -0800 (PST)
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH v2] d80211: Add software sequence support
Date: Fri, 16 Feb 2007 13:25:47 +0100
Cc: Michael Wu <flamingice@sourmilk.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702141423.27823.IvDoorn@gmail.com> <20070215215722.3db7f3ca@griffin.suse.cz> <20070216130329.5f1dffee@griffin.suse.cz>
In-Reply-To: <20070216130329.5f1dffee@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702161325.47396.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 February 2007 13:03, Jiri Benc wrote:
> On Thu, 15 Feb 2007 21:57:22 +0100, Jiri Benc wrote:
> > Thinking about it more, sdata should be the correct place. It's more
> > per-interface thing than per-BSS (although the difference is small in
> > this particular case).
> 
> ...and thinking about it even more, that won't work with WDS.

You mean storing the sequence counter per-interface won't work,
or per-bss?

Ivo
