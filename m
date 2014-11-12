Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59564 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaKLHbw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 02:31:52 -0500
Received: by mail-wi0-f176.google.com with SMTP id h11so3935776wiw.3
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2014 23:31:50 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUVurGqVhvmn4vNkb_pOKW8++4F9iFjwUGeL8Ap_Tb=2jw@mail.gmail.com>
References: <87d28zdplq.fsf@mat.ucm.es>
	<CANUX_P0f0WAHoq3CsC3V-jp4m3_Q7qLz7X+Mvn1hk9_JPrPTGg@mail.gmail.com>
	<87egtbxs8t.fsf@mat.ucm.es>
	<1415615960.1847.11.camel@sipsolutions.net>
	<8761ellhbc.fsf@mat.ucm.es>
	<CA+icZUVurGqVhvmn4vNkb_pOKW8++4F9iFjwUGeL8Ap_Tb=2jw@mail.gmail.com>
Date: Wed, 12 Nov 2014 08:31:50 +0100
Message-ID: <CA+icZUXM45emQoNfiY_81JQupUAxUeX9Tkxus_szuVxxxSBPvw@mail.gmail.com> (sfid-20141112_083155_329099_5F05C3AE)
Subject: Re: Thinkpad X60s/200s: Intel 3945/5100 works with kernel
 2.6.32-67/3.0.0-32 but not 3.7 vanilla.
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Uwe Brauer <oub@mat.ucm.es>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 12, 2014 at 8:25 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Nov 11, 2014 at 7:31 PM, Uwe Brauer <oub@mat.ucm.es> wrote:
>>
>>    > On Mon, 2014-11-10 at 11:30 +0100, Uwe Brauer wrote:
>>
>>    > You'd need CONFIG_CFG80211_WEXT (or so) as well, but realistically you
>>
>> Thanks indeed that solved the problem. So I can use ubuntu
>> 10.04+jfs+trim+wireless great!
>>
>>    > should stop using wireless extensions and use nl80211 (via the "iw"
>>    > tool) instead.
>>
>> Thanks but I am not sure whether it will work in Ubuntu 10.04 I am
>> currently using.
>>
>

[ To answer myself... ]

> Is 10.04 an LTS version (means support till 2015)?

Yupp (see below).

> Might be there exist some 3rd party or the $-backports which will have
> an iw package.
>

» Ubuntu » Packages » lucid (10.04LTS) » net » iw

iw (0.9.19~ubuntu1) [universe] <--- Activate "universe"!

http://packages.ubuntu.com/lucid/iw

- Sedat -
