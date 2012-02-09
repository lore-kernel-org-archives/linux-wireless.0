Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45816 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2BIUSn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:18:43 -0500
Received: by iacb35 with SMTP id b35so2993430iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 12:18:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201201301108.43737.david.goodenough@btconnect.com>
References: <1327581689-22090-1-git-send-email-victorg@ti.com>
 <201201301035.19044.david.goodenough@btconnect.com> <CAGRGNgVhSdTNnmfw0=KHYEEz1r=5=uQbUNvPwTXODnS3LJmr=w@mail.gmail.com>
 <201201301108.43737.david.goodenough@btconnect.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 9 Feb 2012 12:18:23 -0800
Message-ID: <CAB=NE6XaUyzcse3kbUzz97O8t+k66afFB0L+C2v6KHoaKGuURg@mail.gmail.com> (sfid-20120209_211855_683248_FAA4D4A6)
Subject: Re: [RFC 0/7] hostap: add DFS master ability
To: David Goodenough <david.goodenough@btconnect.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 30, 2012 at 3:08 AM, David Goodenough
<david.goodenough@btconnect.com> wrote:
> On Monday 30 Jan 2012, Julian Calaby wrote:
>> On Mon, Jan 30, 2012 at 21:35, David Goodenough
>>
>> <david.goodenough@btconnect.com> wrote:
>> > On Monday 30 Jan 2012, Goldenshtein, Victor wrote:
>> >> On Thu, Jan 26, 2012 at 9:27 PM, David Goodenough
>> >>
>> >> <david.goodenough@btconnect.com> wrote:
>> >> > As I understand it hostapd is not involved in mesh (802.11s) networks,
>> >> > so how does this integrate there?  As I understand it 802.11s is
>> >> > entirely done in the kernel.
>> >>
>> >> At this point we don't have any plans to extend DFS support to mesh
>> >> networks.
>> >
>> > That is fine, and obviously your choice.  My point is simply that
>> > provision so that someone else can add it would be sensible, and in
>> > particular to assume that anything that could have mesh support would
>> > have a userland component kind of locks it out as I understand 802.11s
>> > support at the moment.
>>
>> I understand that using *secure* mesh requires a userspace component:
>>
>> http://o11s.org/trac/wiki/HOWTO
>>
>> Arguably there's no reason why a separate userspace component couldn't
>> handle DFS for mesh interfaces. A project for the future could be to
>> split it out of hostapd so it can be re-used for interfaces that
>> aren't managed by hostapd.
>>
>> Thanks,
> True, I had not thought of that one.  So maybe it would be worth making
> the DFS code in hostapd sufficiently modular that it can easily be moved/
> copies/re-implemented into other environments.

The secure mesh userspace stuff IMHO should be stuffed into hostapd.

  Luis
