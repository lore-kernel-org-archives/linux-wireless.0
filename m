Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55163 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab2A3LCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 06:02:22 -0500
Received: by iacb35 with SMTP id b35so5028675iac.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 03:02:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201201301035.19044.david.goodenough@btconnect.com>
References: <1327581689-22090-1-git-send-email-victorg@ti.com>
 <201201261927.17754.david.goodenough@btconnect.com> <CAK80WHZr484-9Ap2hxm1S59rBAh8z2hHOZ3c5w+cNLSakK_Cgg@mail.gmail.com>
 <201201301035.19044.david.goodenough@btconnect.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 30 Jan 2012 22:02:00 +1100
Message-ID: <CAGRGNgVhSdTNnmfw0=KHYEEz1r=5=uQbUNvPwTXODnS3LJmr=w@mail.gmail.com> (sfid-20120130_120226_157238_9CA1BDAC)
Subject: Re: [RFC 0/7] hostap: add DFS master ability
To: David Goodenough <david.goodenough@btconnect.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 30, 2012 at 21:35, David Goodenough
<david.goodenough@btconnect.com> wrote:
> On Monday 30 Jan 2012, Goldenshtein, Victor wrote:
>> On Thu, Jan 26, 2012 at 9:27 PM, David Goodenough
>>
>> <david.goodenough@btconnect.com> wrote:
>> > As I understand it hostapd is not involved in mesh (802.11s) networks,
>> > so how does this integrate there?  As I understand it 802.11s is entirely
>> > done in the kernel.
>>
>> At this point we don't have any plans to extend DFS support to mesh
>> networks.
> That is fine, and obviously your choice.  My point is simply that provision
> so that someone else can add it would be sensible, and in particular to
> assume that anything that could have mesh support would have a userland
> component kind of locks it out as I understand 802.11s support at the
> moment.

I understand that using *secure* mesh requires a userspace component:

http://o11s.org/trac/wiki/HOWTO

Arguably there's no reason why a separate userspace component couldn't
handle DFS for mesh interfaces. A project for the future could be to
split it out of hostapd so it can be re-used for interfaces that
aren't managed by hostapd.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
