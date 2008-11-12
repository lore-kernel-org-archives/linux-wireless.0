Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:59919 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYKLKsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 05:48:08 -0500
Received: by nf-out-0910.google.com with SMTP id d3so178388nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2008 02:48:05 -0800 (PST)
Message-ID: <cc2a6eec0811120248q1a0850deg390aec1549700cd0@mail.gmail.com> (sfid-20081112_114814_701405_26740469)
Date: Wed, 12 Nov 2008 12:48:04 +0200
From: EforeZZ <EforeZZ@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: broadcom driver
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

We're trying to write a broadcom WiFi driver for FreeBSD.
We looked at M$ Windows driver and found these structures..
We'd be very grateful if anyone tells the standard and/or description
of what these values may mean..

struct _locale_info_t
{
   unsigned char   valid_channels[28];
   struct radar_channels;
   struct restricted_channels;
   unsigned char   maxpwr[6];
   unsigned char   pub_maxpwr[5];
   unsigned char   flags;
};

struct _locale_info_t _locale_b = {
   { 254, 63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0},
   _chanvec_none,
   _chanvec_none,
   { 76, 76, 76, 76, 76, 76 },
   { 20, 20, 20, 0, 0 },
   1 };

struct _locale_info_t _locale_13 = {
   {0, 0, 0, 0, 16, 17, 17, 17, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0 }
   _radar_set1,
   _chanvec_none,
   { 84, 84, 84, 0, 0, 0 },
   { 23, 23, 0, 0, 0 },
   3 };

struct _locale_info_t _locale_15 = {
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0 },
   _chanvec_none,
   _chanvec_none,
   { 0, 0, 0, 0, 0, 0 },
   { 0, 0, 0, 0, 0 },
   0 };

struct _locale_mimo_info_t
{
   unsigned char   val[32];
};

struct _locale_mimo_info_t _locale_fn = {
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 16, 0, 0, 0 };

struct _locale_mimo_info_t _locale_15n = {
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 16, 0, 0, 0 };


struct _country_info_t
{
   unsigned char         abbrev[4];
   struct _locate_info_t      locale_2G;
   struct _locate_info_t      locale_5G;
   struct _locale_mimo_info_t   locale_mimo_2G;
   struct _locale_mimo_info_t   locale_mimo_5G;
} cntry_locales[] =
{
{'UA', _locale_b, _locale_15, _locale_fn, _locale_15n},
{'UA1', _locale_b, _locale_13, _locale_fn, _locale_15n},
};

-- 
Best regards,
EforeZZ
