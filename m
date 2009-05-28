Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:58753 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335AbZE1JD4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 05:03:56 -0400
Received: by bwz22 with SMTP id 22so5279365bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 28 May 2009 02:03:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090528084050.GA4401@tuxdriver.com>
References: <bug-13317-10286@http.bugzilla.kernel.org/>
	 <20090528000253.c731179c.akpm@linux-foundation.org>
	 <20090528084050.GA4401@tuxdriver.com>
Date: Thu, 28 May 2009 11:03:57 +0200
Message-ID: <a32f33a40905280203x772f0628ub0ab2f57b3b21da1@mail.gmail.com>
Subject: Re: [Bugme-new] [Bug 13317] New: No rt2x00 modules in RT kernels.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, dandart@googlemail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 28, 2009 at 10:40 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Thu, May 28, 2009 at 12:02:53AM -0700, Andrew Morton wrote:
>
>> Presumably there's some bustage in the rt2x00 driver which makes it not
>> work with -rt kernels.
>>
>> Did the -rt guys tell the wireless guys about this?
>
> Honestly, I don't recall hearing about it.  Ivo?

No, I can't recall any -rt specific issues either, and so far no
regular open bug
is critical enough to make rt2x00 depend on CONFIG_BROKEN.

Ivo
