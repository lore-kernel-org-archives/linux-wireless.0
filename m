Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54366 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab1DFSt0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 14:49:26 -0400
Received: by qwk3 with SMTP id 3so1060856qwk.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2011 11:49:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1302099854.14995.115.camel@wwguy-huron>
References: <1301945671.14995.110.camel@wwguy-huron> <20110406141258.GA11941@tuxdriver.com>
 <1302099870.4090.3.camel@jlt3.sipsolutions.net> <20110406142711.GB11941@tuxdriver.com>
 <1302099854.14995.115.camel@wwguy-huron>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 6 Apr 2011 20:49:05 +0200
Message-ID: <BANLkTi=mrU7mgiB=E6tJN1Z1Qz_g8RdEUw@mail.gmail.com>
Subject: Re: new maintenance release of iwlwifi 1000 uCode available
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 6, 2011 at 4:24 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> On Wed, 2011-04-06 at 07:27 -0700, John W. Linville wrote:
>> On Wed, Apr 06, 2011 at 04:24:30PM +0200, Johannes Berg wrote:
>> > On Wed, 2011-04-06 at 10:12 -0400, John W. Linville wrote:
>> > > On Mon, Apr 04, 2011 at 12:34:31PM -0700, Guy, Wey-Yi wrote:
>> > > > Hi,
>> > > >
>> > > >         Maintenance release version 39.31.5.1 of uCode for Intel 1000BGN
>> > > >         Series
>> > > >         WiFi Adapter is now available for download from
>> > > >         http://intellinuxwireless.org/?n=Downloads
>> > > >
>> > > >         Changes:
>> > > >         - Fix "tid mismatch" issue
>> > > >
>> > > >         Wey-Yi
>> > >
>> > > Hmmm...the previous release was 128.50.3.1...
>> > >
>> > > I realize that the API portion advanced from 3.1 to 5.1, but the
>> > > overall release number appears to be moving backwards.  Is this
>> > > intentional?
>> >
>> > They're all over the place and basically random ... I *think* they
>> > depend on the branch it comes from internally, but I'm not even sure.
>>
>> OK, I can cope.  But if you (i.e. your team) can influence them
>> towards a sane numbering scheme, it will probably make packagers
>> and/or release engineers happier in the distros...
>>
> I will give feedback to our build engineer team, thanks
>
> Wey
>

Perhaps formatting the number as "3.1.128.50" and "5.1.39.31" would be
a saner idea.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
