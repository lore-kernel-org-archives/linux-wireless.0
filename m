Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63546 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab3AHBsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 20:48:22 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so13689223qcr.33
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2013 17:48:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130107110759.GC6931@redhat.com>
References: <20120418203543.GA16000@x61.home> <20120425122554.GD2466@redhat.com>
 <20120503182853.GA12461@mac.home> <20121226185425.GA12627@x61.home> <20130107110759.GC6931@redhat.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Tue, 8 Jan 2013 01:48:01 +0000
Message-ID: <CAJZjf_z71tqE5pdiJtUXpuPj1eCRRF+EdygZb_zQLnem5izxwA@mail.gmail.com> (sfid-20130108_024826_285264_CEE2EA72)
Subject: Re: Power saving features for iwl4965
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Tino Keitel <tino.keitel@tikei.de>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 7, 2013 at 11:08 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Hi
>
> On Wed, Dec 26, 2012 at 07:54:25PM +0100, Tino Keitel wrote:
>>
>> Hi Stanislaw,
>>
>> is there any progress regarding this? If not, I could try to implement
>> it in the current kernel.  However, I don't have any knowlegde about
>> hardware related features.  If you have, maybe I could use your
>> knowledge to do it myself.
>
> I posted patch here
> http://marc.info/?l=linux-wireless&m=135601033021616&w=2
>
> But I did not review code regarding power save to catch possible
> problems. Testing are bug reporting are welcome ...

Is the firmware crashing only after suspend? Or 'always'? (iwl3945)
