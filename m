Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:36890 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410Ab0AFWpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 17:45:51 -0500
Received: by iwn32 with SMTP id 32so1931607iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 14:45:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e891001061440l38a4d45fp769f02f10bd628de@mail.gmail.com>
References: <1262362872-10251-1-git-send-email-hauke@hauke-m.de>
	<43e72e891001061427l70a6711dg6e96d93679ccc17e@mail.gmail.com>
	<43e72e891001061438x750597d8h658ffd2925180e6b@mail.gmail.com>
	<43e72e891001061440l38a4d45fp769f02f10bd628de@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 6 Jan 2010 14:45:30 -0800
Message-ID: <43e72e891001061445i6b77e785h8348cd4702387d3@mail.gmail.com>
Subject: Re: [PATCH 0/5] compat-wireless: Activate ssb and libertas, refresh
	script
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 6, 2010 at 2:40 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, Jan 6, 2010 at 2:38 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Wed, Jan 6, 2010 at 2:27 PM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>>> On Fri, Jan 1, 2010 at 8:21 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>>> The first two patches were already send some time ago, but not applied,
>>>> the second patch was applied partly. Patch 3 adds an refresh option to
>>>> admin-update.sh and it was used in patch 4. The last patch fixes some
>>>> small problems in admin-update.sh
>>>
>>> All applied. I really liked the quilt patch, thanks so much, I didn't
>>> know quilt could do that, that's awesome. It will certainly help with
>>> keeping compat-wireless up to date as that is the most frequent thing
>>> we have to do.
>>
>> Hm, that quilt trick didn't work for me. I get:
>>
>> Refresh backport patch: patches.orig/01-netdev.patch
>> Patch 01-netdev.patch is applied
>> File series fully applied, ends at patch 06-header-changes.patch
>> Refreshing patches.orig/01-netdev.patch failed, update it
>> use quilt edit [filename] to apply the failed part manually
>> use quilt refresh after the files are corrected and rerun this script
>
> Oh I wonder if in this case it is because patch #1 touches iface.c and
> then so does patch #17.

Nah, that wasn't it. Oh well. I'll do it the old way for now.

  Luis
